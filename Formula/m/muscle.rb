class Muscle < Formula
  desc "Multiple sequence and structure alignment"
  homepage "https://drive5.com/muscle"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/v5.3.tar.gz"
  sha256 "74b22a94e630b16015c2bd9ae83aa2be2c2048d3e41f560b2d4a954725c81968"
  license "GPL-3.0-only"

  depends_on "python@3.14" => :build

  on_macos do
    depends_on "libomp"
  end

  resource "vcxproj_make" do
    url "https://raw.githubusercontent.com/rcedgar/vcxproj_make/806d016858484236d1be4f25edb4c3b3bcac0b62/vcxproj_make.py"
    sha256 "902735703004c47705ffa389329378f237fecb154945b489edf6abe260c6694f"
  end

  # Fix failed assertion on aarch64 Linux
  # PR ref: https://github.com/rcedgar/muscle/pull/104
  patch do
    url "https://github.com/rcedgar/muscle/commit/b29890dfd9e5348c9e7d8fec360ffd16fcf7361b.patch?full_index=1"
    sha256 "c28f117a6358bed002deeb0933c65789d8d3705e1367f40d82148660bda4a6cb"
  end

  def install
    ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp" if OS.mac?

    resource("vcxproj_make").stage buildpath
    cd "src" do
      system "python3", "../vcxproj_make.py", "--openmp"
    end
    bin.install "bin/muscle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle --version")

    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"muscle", "-align", "test.fasta", "-output", "output.fasta"
    assert_path_exists "output.fasta"
  end
end
