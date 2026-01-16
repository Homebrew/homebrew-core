class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "c273bd60c91e6d583be229eb79c6c23df8fbbb64afae0a66931f2bae94202f46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "568562d2b9cd779e7981fe36481e819e1e05786c2980ef05a763e4d5f04f243c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409076155f2c65dfca6725f6fb001e2ea4725efa9a6cbda96ee42a9e703725d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5515994f8ae74a2bb8d3240160ebf79edeb91ae91205618a40294c233a83dffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf6587be257dadd0609ddd8008ae60584e4ce5b498f1779e368852b58d93ad1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcd7391f6dc9184ebfcebf6e7e42089f72f3e01ccec03dafe33d9d9e96c6e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6b91feea27e7444f96ac85140390578063689ebe58cc0d06a87fed57e70a3a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, bin/"docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
