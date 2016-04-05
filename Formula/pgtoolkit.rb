class Pgtoolkit < Formula
  desc "Tools for PostgreSQL maintenance"
  homepage "https://github.com/grayhemp/pgtoolkit"
  url "https://github.com/grayhemp/pgtoolkit/archive/v1.0.2.tar.gz"
  sha256 "d86f34c579a4c921b77f313d4c7efbf4b12695df89e6b68def92ffa0332a7351"

  bottle do
    cellar :any_skip_relocation
    sha256 "b194cb25016dff31295a0b782413e21f4cfdb97331573c6920f7a19c8a888f01" => :el_capitan
    sha256 "3a4b78ebf326a158bc9eb6f1052eb1d3a95c6f4fcf7d7c5894da844cca324232" => :yosemite
    sha256 "ca0c459a7ab2192786b3de034aa26016c5fdee75c58ec8bcb6d0e7d2a1fd784b" => :mavericks
  end

  # depends on system Perl, no other dependencies

  def install
    executables = [
      "pgcompact",
    ]

    docs = [
      "CHANGES.md",
      "LICENSE.md",
      "README.md",
      "TODO.md",
    ]

    executables.each { |executable| bin.install "fatpack/#{executable}" }
    docs.each { |document| doc.install document }
  end

  test do
    output = IO.popen("#{bin}/pgcompact --help")
    matches = output.readlines.select { |line| line =~ /pgcompact - PostgreSQL bloat reducing tool/ }

    !matches.empty?
  end
end
