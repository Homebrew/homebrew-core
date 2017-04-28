## TODO Prebuilt version, to be updated for build from source

class J2objc < Formula
  desc "Java to iOS Objective-C translation tool and runtime. (Prebuilt)"
  homepage "http://j2objc.org"
  url "https://github.com/google/j2objc/archive/1.3.1.zip"
  sha256 "bd05db67fb233dfe7b58cefc899afb8f35099eae0e4b8a6486a398472fb2fac3"

  def shim_script(target)
    <<-EOS.undent
    #!/bin/bash
    export J2OBJC_HOME=#{libexec}
    "#{libexec}/#{target}" "$@"
    EOS
  end

  def install
    libexec.install %w[lib include]
    man.install Dir["man/*"]
    libexec.install "j2objc"
    libexec.install "j2objcc"
    libexec.install "cycle_finder"
    (bin+"j2objc").write shim_script("j2objc")
    (bin+"j2objcc").write shim_script("j2objcc")
    (bin+"cycle_finder").write shim_script("cycle_finder")
# bin.install_symlink libexec/"j2objc"
# bin.install_symlink libexec/"j2objcc"
# bin.install_symlink libexec/"cycle_finder"
# system "./configure", "--disable-debug",
#                      "--disable-dependency-tracking",
#                      "--disable-silent-rules",
#                      "--prefix=#{prefix}"
# system "make", "install"
  end

  test do
    # system "false"
  end
end
# Documents : https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#             http://www.rubydoc.info/github/Homebrew/brew/master/Formula
