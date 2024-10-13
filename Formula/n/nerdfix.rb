class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "37f13ccf0eb6567b31862bc46e694a60177cbf5b76667fe73f22cef8f7ea68df"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "548bbdbad743bb28524493de7787f61c17f5275a3213825364a197e7a6e8e001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d5798e7f09af5bb1fcb64a7e502ecfddb3fc4ead85c5611e3e2bd7210fe13cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daef9dbadb1db61fefd923a3699b3a9edbf8d8e9ace06db181fdd4e150d181bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f757476796838ce2f18d9dc9e9b25f9e561f6c3fed81b85a2b91bcab03b4480f"
    sha256 cellar: :any_skip_relocation, sonoma:         "236056a7d51fcf434977df5b05aa8c29c93cec4db96c202bc2931737ad5de28a"
    sha256 cellar: :any_skip_relocation, ventura:        "48758a489aacd7bdf98f3943ded3ee3f7a825ab56a0edbaf296e780ec59a108a"
    sha256 cellar: :any_skip_relocation, monterey:       "e57e9613e67a27b46c6959483c24f72630c614c2cfd0a9108ead154a19dfcdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e22edc2daee1185ccef621bb5ebcaaf5e8b2544194843cfbafc8e850f5683b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end
