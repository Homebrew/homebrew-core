class Gwt < Formula
  desc "Google web toolkit"
  homepage "http://www.gwtproject.org/"
  url "https://storage.googleapis.com/gwt-releases/gwt-2.8.2.zip"
  sha256 "970701dacc55170088f5eb327137cb4a7581ebb4734188dfcc2fad9941745d1b"

  bottle :unneeded

  def install
    rm Dir["*.cmd"] # remove Windows cmd files
    libexec.install Dir["*"]

    # Don't use the GWT scripts because they expect the GWT jars to
    # be in the same place as the script.
    (bin/"webAppCreator").write <<~EOS
      #!/bin/sh
      HOMEDIR=#{libexec}
      java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.user.tools.WebAppCreator "$@";
    EOS

    (bin/"benchmarkViewer").write <<~EOS
      #!/bin/sh
      APPDIR=#{libexec}
      java -Dcom.google.gwt.junit.reportPath="$1" -cp "$APPDIR/gwt-dev.jar" com.google.gwt.dev.RunWebApp -port auto $APPDIR/gwt-benchmark-viewer.war;
    EOS

    (bin/"i18nCreator").write <<~EOS
      #!/bin/sh
      HOMEDIR=#{libexec}
      java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.i18n.tools.I18NCreator "$@";
    EOS
  end

  test do
    system bin/"webAppCreator", "sh.brew.test"
    assert_predicate testpath/"src/sh/brew/test.gwt.xml", :exist?
  end
end
