class Flaresolverr < Formula
  require "language/node"

  desc "Proxy server to bypass Cloudflare protection"
  homepage "https://github.com/FlareSolverr/FlareSolverr"
  url "https://github.com/FlareSolverr/FlareSolverr/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "2727dda2efa1ba9ce1374c52e0d0cd2d950bdb7fba98076c76aedebd625ac30d"
  license "MIT"
  head "https://github.com/FlareSolverr/FlareSolverr.git", branch: "master"

  depends_on "node@16"

  def node
    deps.reject(&:build?)
        .map(&:to_formula)
        .find { |f| f.name.match?(/^node(@\d+(\.\d+)*)?$/) }
  end

  def install
    libexec.install Dir["*"]

    cd libexec do
      ENV["PUPPETEER_SKIP_DOWNLOAD"] = "1"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end

    puppeteer_download_path = var/"flaresolverr/puppeteer"
    puppeteer_download_path.mkpath

    (bin/"flaresolverr").write <<~EOS
      #!/bin/bash
      DEFAULT_PUPPETEER_EXECUTABLE_PATH=(${PUPPETEER_DOWNLOAD_PATH:-"#{puppeteer_download_path}"}/*/Firefox*.app/Contents/MacOS/firefox)
      export PUPPETEER_EXECUTABLE_PATH="${PUPPETEER_EXECUTABLE_PATH:-$DEFAULT_PUPPETEER_EXECUTABLE_PATH}"
      export PUPPETEER_PRODUCT="${PUPPETEER_PRODUCT:-firefox}"
      exec "#{node.opt_bin}/node" "#{libexec}/dist/server.js" "$@"
    EOS

    (bin/"flaresolverr-install-browser").write <<~EOS
      #!/bin/bash

      cd "#{libexec}" || exit

      export PUPPETEER_DOWNLOAD_PATH="${PUPPETEER_DOWNLOAD_PATH:-"#{puppeteer_download_path}"}"
      export PUPPETEER_PRODUCT="${PUPPETEER_PRODUCT:-firefox}"

      OPTIND=1
      while getopts "hr" opt; do
        case "$opt" in
          h)
            echo "usage: $(basename $0) [-h] [-r]"
            echo "  -h    show help"
            echo "  -r    remove existing browser and reinstall"
            exit 0
            ;;
          r)
            if [[ -d "$PUPPETEER_DOWNLOAD_PATH" ]]; then
              rm -rf "$PUPPETEER_DOWNLOAD_PATH" || exit
              echo "Removed existing local browser installation."
            fi
            ;;
        esac
      done &&
      shift $(( OPTIND - 1 ))
      [[ "$1" == "--" ]] && shift

      # Install nightly version of Firefox required by Puppeteer.
      exec "#{node.opt_bin}/node" node_modules/puppeteer/install.js
    EOS

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  def caveats
    <<~EOS
      Before you can use flaresolverr, you must run `flaresolverr-install-browser` to locally install a nightly version of Firefox.
    EOS
  end

  plist_options startup: true
  service do
    run "#{bin}/flaresolverr"
    environment_variables CAPTCHA_SOLVER: "none", LOG_HTML: "false", LOG_LEVEL: "info"
    keep_alive true
    log_path var/"log/flaresolverr.log"
    error_log_path var/"log/flaresolverr.log"
  end

  test do
    ENV["PUPPETEER_DOWNLOAD_PATH"] = testpath/"puppeteer"

    system opt_bin/"flaresolverr-install-browser"

    port = free_port

    pid = fork do
      ENV["PORT"] = port.to_s
      exec opt_bin/"flaresolverr"
    end
    sleep 10

    begin
      output = JSON.parse(shell_output("curl --silent http://localhost:#{port}"))

      assert_equal "FlareSolverr is ready!", output["msg"]
      assert_match "v#{version}", output["version"]
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
