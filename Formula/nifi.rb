class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.3/nifi-1.15.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.15.3/nifi-1.15.3-bin.tar.gz"
  sha256 "c77fe8e4bc534f16fd5482832285e0bde07495308f31fd6d0fbb3118042daed4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12670415f1b40bfebb1939fb1b1072159c572a2aa047a3bc369e74b7c99097cf"
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
