
class J2objc < Formula
  desc "Java to iOS Objective-C translation tool and runtime. (Prebuilt)"
  homepage "http://j2objc.org"
  url "https://github.com/google/j2objc/releases/download/1.3.1/j2objc-1.3.1.zip"
  sha256 "bd05db67fb233dfe7b58cefc899afb8f35099eae0e4b8a6486a398472fb2fac3"

  depends_on :java => "1.8+"

  def shim_script(target)
    <<-EOS.undent
      #!/bin/bash
      export J2OBJC_HOME=#{libexec}
      "#{libexec}/#{target}" "$@"
    EOS
  end

  def install
    puts "[Info] Installing, it take a while."
    libexec.install %w[lib include]
    man.install Dir["man/*"]
    libexec.install "j2objc"
    libexec.install "j2objcc"
    libexec.install "cycle_finder"
    (bin+"j2objc").write shim_script("j2objc")
    (bin+"j2objcc").write shim_script("j2objcc")
    (bin+"cycle_finder").write shim_script("cycle_finder")
  end

  test do
    puts "[Testing] Installing, it take a while."
    system "#{bin}/j2objc"
    system "#{bin}/j2objcc", "--version"
  end
end
