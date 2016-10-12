class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "https://ceylon-lang.org/"
  url "https://ceylon-lang.org/download/dist/1_3_0"
  sha256 "da4cca018c5d108fe202ed37b19a1c49f61338251974b5d3b781ead33e3599a8"

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
