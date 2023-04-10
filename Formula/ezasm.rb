class Ezasm < Formula
  desc "Assembly-like programming language for use in education"
  homepage "https://github.com/ezasm-org/EzASM"
  url "https://github.com/ezasm-org/EzASM-releases/releases/latest/download/EzASM-1.3.4-beta-full.jar"
  sha256 "667e9ae8bfc347ffa2310bcd503b454717710539666f18bd3c46841486b6c62f"
  license "MIT"

  livecheck do
    url "https://github.com/ezasm-org/EzASM-releases/releases/latest"
    strategy :page_match
    regex(%r{href=.*?/EzASM-(.*?)-full.jar}i)
  end

  depends_on "openjdk@17"

  def install
    bin.install "EzASM-#{version}-full.jar" => "ezasm"
  end

  test do
    puts shell_output("#{bin}/ezasm --version")
  end
end
