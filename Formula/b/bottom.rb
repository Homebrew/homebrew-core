class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.10.2.tar.gz"
  sha256 "1db45fe9bc1fabb62d67bf8a1ea50c96e78ff4d2a5e25bf8ae8880e3ad5af80a"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9bb56477f24536e5ae48b06159e337d9fd0c3ab67710950f59af2aca2be62f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4c0dac75255ca0efe25e8d675f66a7509d24e03057aa9806bd2f5874d613056"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b78a76d3659944b74e7ca4b0f3c061b1a472da89363f63d06efda99c695fb5ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92b42d2bf6ef560605216e9616d8c01f365a126810f3c4083e804c95b45b0ecc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e9f22ad7b0098ca07750d864c62c37d6c939a2fe2e21b7e8a145c99200ea2df"
    sha256 cellar: :any_skip_relocation, ventura:        "d3db0527a8a8ac6d9e1efabd7a7824795bd149a425bd2b815049d836c65bb2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc6b1021908df82dd39bdf2c5541999c6d9a30e9a23f22c52687f00a3eebb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb486c2507d3b31db2c4ea932bf1b5da0d41fe9a50c0c683ec2e008d12acb0f"
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
