class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.10/pickle.phar"
  sha256 "8d06ed7c09faf08f8e65119d4ca1a6cbbb121b140c7b199b4b6ca15afcd7f02f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b6a5e839808afaf5e61450c3b041473a7c4cbfd933c9533a9c20ec5ad6b2259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b6a5e839808afaf5e61450c3b041473a7c4cbfd933c9533a9c20ec5ad6b2259"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ebad05ada35280198568e3f376c8803cb61d245662eca6041220684bb083fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5ebad05ada35280198568e3f376c8803cb61d245662eca6041220684bb083fc"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ebad05ada35280198568e3f376c8803cb61d245662eca6041220684bb083fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6a5e839808afaf5e61450c3b041473a7c4cbfd933c9533a9c20ec5ad6b2259"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
