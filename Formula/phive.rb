class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.15.1/phive-0.15.1.phar"
  sha256 "dfd3804452a20bca40c1c8e5f7a2cd0f470bc442c43f256c890990becc467bb0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33caa5904fa5d90086354429d57e4e4ddf7e2e5e649090f9c7e187e67d75d580"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
