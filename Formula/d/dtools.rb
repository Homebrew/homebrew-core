class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.109.1.tar.gz"
  sha256 "6f9db3ec124356f1ba6b10681e6bb07e364a434faf8d1644ef2e254b90a16459"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "014f22a3cb9d11924138766bcb02867a949faf4d555287c8aa37a29358047de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4da9f80c0dd636bdbdc3dc13440887df95716c9f718a64ea7ba9eacf69f41c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07da51134f24a745adfde5e2876e6cf81b650e3286648e5cce94b7e289eb450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422bb5c6da88abfe0055afa0e8d0a57f1d039b18cd1ecf70903dad2b946a3f5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "58cc9814b16fe73c3223b9190aad9e4208671f1272f2458fb02d1e77c03708bd"
    sha256 cellar: :any_skip_relocation, ventura:        "dbfd5583ea5a1a2f26aad14c97152bef1599157fc6679f6d9949815eecc6ce73"
    sha256 cellar: :any_skip_relocation, monterey:       "6344b77d8ab17334e4ccac3c3ab53d6c617871cf2a7c1ddda56ec502abdff3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcfd9495f99afff506110cd6bdf016c70b993f4437fab7567fa3e56bf0d46eb"
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
