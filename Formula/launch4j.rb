class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://git.code.sf.net/p/launch4j/git.git",
      tag:      "Release_launch4j-3_50",
      revision: "0b6f1c1ffe4e83dc47fa866a733dbf0125237937"
  license all_of: ["BSD-3-Clause", "MIT"]

  livecheck do
    url :stable
    regex(/^(?:Release_launch4j[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:  "15f9a731ba37cfd7cf90365c98f8d59ac5c5e482d2caf7561c83adccb81e8f16"
    sha256 cellar: :any_skip_relocation, monterey: "65e2841bc477c9fb1368d5fb38fa875a1f4233d75885a4a6e61eadf1e2eea2ae"
    sha256 cellar: :any_skip_relocation, big_sur:  "23513b54485b601791605269df164cdf4c77c84d122c61fff6db3bb5b65c8e59"
    sha256 cellar: :any_skip_relocation, catalina: "8c114ad97d89fad8a9a1a9c6e54d1ce0604f28b71929438db26e97bda57eb58e"
  end

  depends_on "ant" => :build
  depends_on arch: :x86_64
  # Installs a pre-built `ld` and `windres` file with linkage to zlib
  depends_on :macos
  depends_on "openjdk"

  def install
    system "ant", "compile"
    system "ant", "jar"
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
