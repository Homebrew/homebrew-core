class GoGui < Formula
  desc "GUI for playing Go over Go Text Protocol"
  homepage "https://gogui.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gogui/gogui/1.4.9/gogui-1.4.9.zip"
  sha256 "32684b756ab5b6bf9412c035594eddfd1be9250de12d348c3501850857b86662"

  head do
    url "https://git.code.sf.net/p/gogui/code.git"

    depends_on "docbook" => :build
    depends_on "docbook-xsl" => :build
  end

  depends_on :ant => :build
  depends_on :java => "1.6"

  resource "quaqua" do
    url "https://www.randelshofer.ch/quaqua/files/quaqua-5.4.1.nested.zip"
    sha256 "a01ce8bcce6e81941ca928468e728e76e0773957c685c349474ee04f3be677d6"
  end

  def install
    inreplace "build.xml", "/Developer/Tools/SetFile", "/usr/bin/SetFile"
    if build.head?
      resource("quaqua").stage do
        system "unzip", "quaqua-*.zip"
        (buildpath/"lib").install "Quaqua/dist/quaqua.jar"
      end
      args = %W[
        -Ddocbook-xsl.dir=#{Formula["docbook-xsl"].prefix}/docbook-xsl
        -Ddocbook.dtd-4.2=#{Formula["docbook"].prefix}/docbook/xml/4.2
      ]
    else
      args = %w[
        -Ddoc-uptodate=true
      ]
    end
    system "ant", "gogui.app", *args
    prefix.install "build/GoGui.app"
    bin.write_exec_script "#{prefix}/GoGui.app/Contents/MacOS/JavaApplicationStub"
    mv "#{bin}/JavaApplicationStub", "#{bin}/gogui"
  end

  test do
    assert_equal "GoGui #{version}", shell_output("#{bin}/gogui -version").chomp
  end
end
