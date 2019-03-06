class Ghidra < Formula
  desc "Software reverse engineering framework"
  homepage "https://ghidra-sre.org/"
  url "https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip"
  version "9.0"
  sha256 "3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2"
  depends_on :java => "11.0+"

  def install
    rm Dir["support/*.bat"]
    rm Dir["server/*.bat"]
    rm Dir["*.bat"]
    prefix.install Dir["*"]
    (bin/"ghidra").write_env_script(prefix/"ghidraRun", Language::Java.java_home_env("11"))
  end

  test do
    (testpath/"project").mkpath
    mkdir("#{HOMEBREW_CACHE}/java_cache")
    system "#{prefix}/support/analyzeHeadless", "#{testpath}/project", "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_predicate (testpath/"project/HomebrewTest.rep"), :exist?
  end
end
