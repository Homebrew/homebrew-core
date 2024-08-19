class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.27.0/nifi-1.27.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.27.0/nifi-1.27.0-bin.zip"
  sha256 "15a03ec378afe653b97b1a8110c3bd1f8e4238c52a921e902f9203181075c849"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, sonoma:         "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, ventura:        "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, monterey:       "882eb2dbe88af89ba5fd00fad64d4de27db4fb67aa9c91accfad09ae6fd48588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c4429e38a8f9d05f1a43c1320ca0e7396c1c7a2b29d1d943d34e316df674d6"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
