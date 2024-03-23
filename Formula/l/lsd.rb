class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "7933e196bf7b164ea8879078f8a8e87381e0c49f71867e0036c82916199aba61"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "702c020121354e2beae478935ea97fb6d35546ac6a3930d103608f6ac6aa87b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29de1b0bb8a46c5fb0f99f56392e96a8be28bd20a793479ad273237d8c98e1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1017dce4bc01fe7478a774bdf9c6f01b9c8754be1812507585fcba8345079533"
    sha256 cellar: :any_skip_relocation, sonoma:         "21544da7b0f62b9fd0ca837855edb939bd01ca3bf77674a6a57eec723eaa12b3"
    sha256 cellar: :any_skip_relocation, ventura:        "35238fc7ea6ae6f3ffdcaf38b64a0fdec9ecc73d670c1677b4e1228817051320"
    sha256 cellar: :any_skip_relocation, monterey:       "f8b02ccd3a23fea96615537f101abd3ead2a1444906d26b6108a9019508e8b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e197b5e3427f4a3979c9a85b819d48d6be8aafc168b5efa15d7c1f5f886afe8f"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
