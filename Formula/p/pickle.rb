class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  # Bump to PHP 8.5 on the next release, if possible.
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar"
  sha256 "fe68430bbaf01b45c7bf46fa3fd2ab51f8d3ab41e6f5620644d245a29d56cfd6"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d08a3524b6b3addc133a13e292110ebac7ef414b426b8158022afae6eb2a132"
  end

  depends_on "php@8.4"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    # TODO: Switch to following when using unversioned `php`:
    # bin.install "pickle.phar" => "pickle"
    libexec.install "pickle.phar" => "pickle"
    (bin/"pickle").write <<~PHP
      #!#{Formula["php@8.4"].opt_bin}/php
      <?php require '#{libexec}/pickle';
    PHP
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("#{bin}/pickle info apcu"))
  end
end
