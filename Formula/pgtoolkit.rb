class Pgtoolkit < Formula
  desc "Tools for PostgreSQL maintenance"
  homepage "https://github.com/grayhemp/pgtoolkit"
  url "https://github.com/grayhemp/pgtoolkit/archive/v1.0.2.tar.gz"
  sha256 "d86f34c579a4c921b77f313d4c7efbf4b12695df89e6b68def92ffa0332a7351"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "855d67c931981dc3d62ce39fb663f0ece72efc919001352be2902ae1ad491b12"
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
