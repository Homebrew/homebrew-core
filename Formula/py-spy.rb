class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "6c07096d227c08dee8a6526ff0a4ceadbe11eb27a131ab147e9d82dde52f3177"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e7e23078fb6f4cc9e1549dc33030b56a3213d747fb15f2cae7a7a9175db6083"
    sha256 cellar: :any_skip_relocation, big_sur:       "73a98156d4dafa6614709c52ed51e47652fde038348fed6da03b43c40b9935d5"
    sha256 cellar: :any_skip_relocation, catalina:      "dae2729dc5a12091d77f7192e920c21659a05973d1af6a72aaa5bf36b607ceeb"
    sha256 cellar: :any_skip_relocation, mojave:        "f6cc40bca3872cd5bb2afa27d62eb6d676b9dc03678deff3f1da1dde31deaf6b"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"py-spy", "completions", "bash")
    (bash_completion/"py-spy").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"py-spy", "completions", "zsh")
    (zsh_completion/"_py-spy").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"py-spy", "completions", "fish")
    (fish_completion/"py-spy.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/py-spy record python3.9 2>&1", 1)
    assert_match "This program requires root", output
  end
end
