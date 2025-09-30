class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.11.1.tar.gz"
  sha256 "0095ea9edb386ad7c49d845176314097713661d22ec42314e3be46426bc769ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de9d22b6801ba8a01d0a8f4520a4459801733d5fa9194a2e48b3a3f4615321e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc63eb85ed39399defbb86c7019ba0cd02f8d6124dd616dcbe20e797249c3eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d593da907073b7b7d2faf03984475d1d5dd5dc8dc2eb05bc8c511e13ca474d22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56ba2aed8740f7a7294dbea9564ead057d4ee532a86a0c8fcaa590d02456d50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "566e6a599d6c74f5ecd90e1b6cd33db2398794f6e372ab552af79bd03592d166"
    sha256 cellar: :any_skip_relocation, ventura:       "1741b0c277cc36a1716b929eed10503de1b810bcc353ca78b532ef5f7ef58b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a181e21051afbac3f332a127d21d656692b3818f2f2d10983239c839a06708a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66af1991ec590bf5669acf41a040cf303c89df26ffa6cfee579846bcd0a9940"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
