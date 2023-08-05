class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.4.tar.gz"
  sha256 "199123ef354bcabaa8a2e3b7b477b324f5b647d503a2599d08296733846eea6e"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92076abceff90a3c7f660b73adf5e0adc234c8f7596ec6c579da38d874fd3ac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b247a8aafb43fdd5a3ec66477d8ef138f4284d18c7640eb1ef386a247807a42f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81609f5d3a4607e165e79736ef810ceff3d922b235ec786856e0552783e67b1f"
    sha256 cellar: :any_skip_relocation, ventura:        "bbca2225003c688e7d2bf3020e842f0d48ccc36af26871b619a6811cde3b4903"
    sha256 cellar: :any_skip_relocation, monterey:       "1f39b870472782cfe5c6e80ac9171a685986ca56b62c4857dc4da05d9b3f2e2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc9a53febbcf075abd9514f0116478d68721bc108dea424e84ec210d612caf1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "274d0f79df6065a04210199bbe4c1fc06559c6a2558d00f8bca0312f325f2d7b"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
