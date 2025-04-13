class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.111.0.tar.gz"
  sha256 "4c391349e929f73b7ffe97da7b98fbbdb04effda3e6389d9d46dc9d9938ece3b"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6778d202df0d520c381dc2673255dad0f918731e4bf342cb4ec2c6496fd434a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f878981e244a35df18c4e96672b15cef4fed2b6078972201adbb2736891b3d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f98206ff041de733df29b77e9dc282ac33fed0442a086c42f6d90047e7aa24cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef13d4318457fd18617cc7908faf31cca88cb390bbe03b8f12ba1e2e5fba427"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee01bf2167c23fb9735c8cd59a1d4da4e9c8510929b50246dc3921932575515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30acf8b3f1796a504cd7e9cb7d635913c3bcc37c58f48def9799784d7c30c653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6584c89d375ae71783b3317e953db07a4bc0a72f48c68b86eff1dc02b91c8a38"
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
    (testpath/"hello.d").write <<~D
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    D
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end
