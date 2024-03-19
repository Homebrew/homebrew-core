class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "326191265f6b7e10a98a592eedcf54f4fce8d6090a8d5f09919076cea8a53332"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5fb813b3ee034748a549efd5566ea12a0f846239878c2875de93fd7eeb0f08b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bed445865f777152aa6ad279e774f759a1b22915a8d363358d7f2c1d92e0b4f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962abf219e4dedc0cadc8b41b1757b30514edae52a407c115ceafd408f33947b"
    sha256 cellar: :any_skip_relocation, sonoma:         "07c3eabe8d2170c19280c8e7e62c03ee02c255d605bd51018e1a854008521755"
    sha256 cellar: :any_skip_relocation, ventura:        "f47cf20c25963a94a55525eceda1adff070f6c232c68069491cf5be350b7dbf3"
    sha256 cellar: :any_skip_relocation, monterey:       "9eb59a8662ee41d488dc184f87136f369541d78cc7fbf8bed3cb44a0ee96ad55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e402b80b9ab9a1b49ec800623d61afa33aabb85a02f889571470af7c12e84601"
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

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
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
