class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.25.34.tar.gz"
  sha256 "eb3114f39814162537803eb383a103309f7756d5232766c1f6eaff363c1bd19a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    manifest_sha256 "e0bbbda021f74db4f07680b1453283f631f39feb96356211f6a4fbf2f24acece"
    sha256 cellar: :any, arm64_golden_gate: "66db0361e359a7a225a3e39d49237f3fcf9dbbcb6a1ce474571cf65d022794ef"
    sha256 cellar: :any, arm64_tahoe:       "80f6e937188858bf946cbbf9e51dca2fa2e0656a58634d19aaf87d6a47f1dcf0"
    sha256 cellar: :any, arm64_sequoia:     "4d280a6b8624455f286578fcfa5d0c6c90ed6a720c86198de6c0ba33271a319a"
    sha256 cellar: :any, arm64_linux:       "7db1215ba431cae1d5763d7e1af73d92b5fc1a58de97904e424651c85f1b3abe"
    sha256 cellar: :any, x86_64_linux:      "1a00c7f82188bc546904e413360e2f9854b4f4c55376a890f4899da74bd9b208"
  end

  depends_on "dotnet@10"

  allow_network_access! :test

  def dotnet = dep("dotnet").to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath

    system "dotnet", "restore", "src/Jackett.Server", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
