class GitWithGitAt < GitHubGitDownloadStrategy
  def update_submodules
    if !File.exist?(".firstTime")
      # I use git@github.com for all sub-modules.
      # We can not assume all users have keys on github so this will not work
      # The following converts build into an https url. The .configure script
      # will convert all other sub-modules with the "--with-thor-build-on-travis" flag.
      # On subsequent calls we can use the standard version of update_submodules
      system "mv", ".gitmodules", "gitmodules.old"
      system("sed -e 's#git@\\([^:]*\\):#https://\\1/#' gitmodules.old > .gitmodules")
      system "git", "submodule", "update", "--init"
      File.open(".firstTime", "w") {}
    else
      super
    end
  end
end

class Thorsserializer < Formula
  desc "Declarative Serialization Library (Json/Yaml) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git", :using => GitWithGitAt, :tag => "1.5.7"

  ENV["COV"] = "gcov"

  depends_on "libyaml"

  def install
    system "./configure", "--disable-binary", "--disable-vera", "--with-thor-build-on-travis", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
