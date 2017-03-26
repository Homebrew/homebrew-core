class ApacheFlexSdkInstaller < Formula
  desc "The open-source framework for building expressive web and mobile applications"
  homepage "https://flex.apache.org/"
  url "http://mirror.fibergrid.in/apache/flex/installer/3.2/apache-flex-sdk-installer-3.2.0-src.tar.gz"
  version "4.16.0"
  sha256 "f8fb00d300c74609771b23e2bc5d9a97e22f793518245be5596d9a4177236f9e"

  option "with-playerglobal", "Installs PlayerGlobal.swc"

  def install
    Dir["*"].each { |file| cp_r file, File.join(prefix, File.basename(file)) }

    if build.with? "playerglobal"
      (prefix/"framework/libs/player/25.0").mkpath
      resource("flash-playerglobal").fetch
      (prefix/"frameworks/libs/player/25.0").install resource("flash-playerglobal").cached_download => "playerglobal.swc"
      inreplace prefix/"frameworks/flex-config.xml", "/<target-player>11.1<\/target-player>/", "<target-player>25.0</target-player>"
    end
  end

  def caveats; s= <<-EOS.undent
    To use the SDK you will need to:
    (a) Add the bin folder to your $PATH:
      export PATH=$(brew --prefix flex)/bin:$PATH
    (b) Set $FLEX_HOME:
      export FLEX_HOME=$(brew --prefix flex)
    (c) Add the tasks jar to ANT:
      mkdir -p ~/.ant/lib
      ln -s $(brew --prefix flex)/ant/lib/flexTasks.jar ~/.ant/lib
    EOS
    if build.with? "playerglobal"
      s += <<-EOS.undent
      (d) set $PLAYERGLOBAL_HOME:
        export PLAYERGLOBAL_HOME=$(brew --prefix flex)/frameworks/libs/player
      EOS
    end
  end
end
