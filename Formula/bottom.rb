class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.8.tar.gz"
  sha256 "4e4eb251972a7af8c46dd36bcf1335fea334fb670569434fbfd594208905b2d9"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8548c890b957a6eab9aa8a7d118002e26dbac34052475fa78f1d3d49487c4026"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8c839fdca05a6d950252783d523fac967a88fc0c082b7fbd2011e7ca81230d2"
    sha256 cellar: :any_skip_relocation, monterey:       "cf22cc7eb878dcaf924d180ad4dd594dc35757621a792b8587cf86191d3e3246"
    sha256 cellar: :any_skip_relocation, big_sur:        "52339a78eefffa93988110d8c3a3f8587a7eb5a2a3d1e548603c123328a65129"
    sha256 cellar: :any_skip_relocation, catalina:       "11d8fe9834db63ef3ea2b76649887926ac1ced8607cbf99bb72f940593f2913d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3706d2bd6c76b62d89bfb5c265e0df0645485171d38ceebb90af427a3593069"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/bottom-*/out"].first
    bash_completion.install "#{out_dir}/btm.bash"
    fish_completion.install "#{out_dir}/btm.fish"
    zsh_completion.install "#{out_dir}/_btm"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 1)

    fork do
      exec bin/"btm", "--config", "nonexistent-file"
    end
    sleep 1
    assert_predicate testpath/"nonexistent-file", :exist?
  end
end
