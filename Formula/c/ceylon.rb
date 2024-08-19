class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "https://projects.eclipse.org/projects/technology.ceylon"
  url "https://web.archive.org/web/20200623041941/https://downloads.ceylon-lang.org/cli/ceylon-1.3.3.zip"
  sha256 "4ec1f1781043ee369c3e225576787ce5518685f2206eafa7d2fd5cfe6ac9923d"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9e8be2d72811dcc4310d1633801fa34e38a7e2bbc779e945ce732ff03172dc2"
  end

  disable! date: "2024-02-06", because: :deprecated_upstream

  depends_on "openjdk@8"

  def install
    man1.install Dir["doc/man/man1/*"]
    doc.install Dir["doc/*"]
    bin.install "bin/ceylon"
    bin.install "bin/ceylon-sh-setup"
    libexec.install Dir["*"]
    env = Language::Java.java_home_env("1.8")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    cd "#{libexec}/samples/helloworld" do
      system bin/"ceylon", "compile", "--out", "#{testpath}/modules",
                                         "--encoding", "UTF-8",
                                         "com.example.helloworld"
      system bin/"ceylon", "doc", "--out", "#{testpath}/modules",
                                     "--encoding", "UTF-8", "--non-shared",
                                     "com.example.helloworld"
      system bin/"ceylon", "run", "--rep", "#{testpath}/modules",
                                     "com.example.helloworld/1.0", "John"
    end
  end
end
