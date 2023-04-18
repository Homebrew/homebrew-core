class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://github.com/basilioss/mdt/archive/refs/tags/1.2.1.tar.gz"
  sha256 "aac30cef27791d3fa2adc429ac5a3a805cd6e232bee7b2eb50e5592f90efa153"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed1819515c70d8eb3c2bf778d6a52ce8da1e399527c429257f52ba8dcbc13c25"
  end

  depends_on "gum"

  def install
    bin.install "mdt"
  end

  test do
    assert_equal "mdt #{version}", shell_output("#{bin}/mdt --version").chomp
    assert_match "Error: Got an unexpected argument '--invalid'.", shell_output("#{bin}/mdt --invalid 2>&1", 1)
  end
end
