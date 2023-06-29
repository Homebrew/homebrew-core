class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.104.0.tar.gz"
  sha256 "8efedaa3ac8badf3d18acc10b38dc581d992aab102c93ce81d9fc15e09c532fc"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f771ec26451889ec9410d001fff05d4b8674485636009dcbc41543b886c7298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ef867835d384ecbd50f381db6bc2571cca287b649a38736464c6ddc2b980cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1162d621c1a3e4b42f8bb74b9bfd2615feee0cab74172f2c8d614093e71c82"
    sha256 cellar: :any_skip_relocation, ventura:        "58a065864edbba85cf1add00f5d3a376fc7e1aa435c955247b34bbfe96a78f77"
    sha256 cellar: :any_skip_relocation, monterey:       "95e8fc34c3be1ce0082fbe7d895a2285e29ae92dcc9ca969b706ca27266e19ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "3edc9af5e4ecbf1d9630059c288e47682e416893922100ea4c3f57eac6b30ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce815021b9626c6765638734096dc52b80d4acb476398c6d0583b67c8bae09ec"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  link_overwrite "bin/ddemangle"
  link_overwrite "bin/dustmite"
  link_overwrite "bin/rdmd"

  def install
    # We only need the "public" tools, as listed at
    # https://github.com/dlang/tools/blob/master/README.md
    #
    # Skip building dman as it requires getting and building the DMD
    # and dlang.org source trees.
    tools = %w[ddemangle rdmd dustmite]
    system "dub", "add-local", buildpath

    tools.each do |tool|
      system "dub", "build", "--build=release", ":#{tool}"
      bin.install "dtools_#{tool}" => tool
    end

    man1.install "man/man1/rdmd.1"
  end

  test do
    (testpath/"hello.d").write <<~EOS
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    EOS
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end
