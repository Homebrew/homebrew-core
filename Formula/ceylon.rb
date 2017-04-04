class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "https://ceylon-lang.org/"
  url "https://ceylon-lang.org/download/dist/1_3_2"
  sha256 "ec9a3f05a9a361eb1bb5817c5c3930417e8dcf0c46114dca841a5459af2f9c46"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    man1.install Dir["doc/man/man1/*"]
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]

    # Symlink shell scripts but not *.plugin
    bin.install_symlink "#{libexec}/bin/ceylon"
    bin.install_symlink "#{libexec}/bin/ceylon-sh-setup"
  end

  test do
    ENV.java_cache

    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "com.example.helloworld"
      system "#{bin}/ceylon", "doc", "--out", "#{testpath}/modules", "--encoding", "UTF-8", "--non-shared", "com.example.helloworld"
      system "#{bin}/ceylon", "run", "--rep", "#{testpath}/modules", "com.example.helloworld/1.0", "John"
    end
  end
end
