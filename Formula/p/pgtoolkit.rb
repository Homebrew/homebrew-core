class Pgtoolkit < Formula
  desc "Tools for PostgreSQL maintenance"
  homepage "https://github.com/grayhemp/pgtoolkit"
  url "https://github.com/grayhemp/pgtoolkit/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d86f34c579a4c921b77f313d4c7efbf4b12695df89e6b68def92ffa0332a7351"
  license "PostgreSQL"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2ff68677e0eea7a722a102fabbb166117a3e199cb010d10a65f73a2427026a71"
  end

  def install
    bin.install "fatpack/pgcompact"
    doc.install %w[CHANGES.md LICENSE.md README.md TODO.md]
  end

  test do
    output = IO.popen("#{bin}/pgcompact --help")
    matches = output.readlines.select { |line| line.include?("pgcompact - PostgreSQL bloat reducing tool") }
    !matches.empty?
  end
end
