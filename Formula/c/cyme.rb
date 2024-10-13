class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "f3b7f71e52fd29809f25aadff4d949aafe0ff088d514ca587e7103d5b4171d5b"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b938310f07cc908be90678d6bd54c66705d88479f8870714f340bf2265d0050"
    sha256 cellar: :any,                 arm64_sonoma:  "fa4830cdafc737f2fe0074f319f1bdc179189a634202ade7186b9e4e7e43a31f"
    sha256 cellar: :any,                 arm64_ventura: "178d60c19ed59f64695a2101902b70f40de186eb865e2853b14a27cfead4ca78"
    sha256 cellar: :any,                 sonoma:        "b75266dbbca68b5f0bf689cce6930fd4d46a72966112cef5eec421d0cd7eba9e"
    sha256 cellar: :any,                 ventura:       "935cddece9d213e71a3a4af00b08ed4d5802df8a7ae9f4e0de5d71784c7be20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35433b861060d54a7d9ef1345fc2d6bc1329ce9e6d03ffc0ea71164df6a5b157"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
