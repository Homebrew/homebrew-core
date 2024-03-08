class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/2.0.0/orc-tools-2.0.0-uber.jar"
  sha256 "581a7b1cc64487238626abaed0a74d882f97468eeecc64e65ce419f70dcd9125"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, ventura:        "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, monterey:       "5d2fd6e6d7b6c09b591c9f07bebd7bdb9850067c5a625b6514edde66b01ab8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3125344ef3d086497ad3a9528af88f1ebc650d48c40efbef9deb744ef3433e58"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
