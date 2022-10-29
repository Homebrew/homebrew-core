class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.7.tar.gz"
  sha256 "0704abbafa93a42fccba65b9aa77caecd477fa0df4e28a33a453aafe1a763ee0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
