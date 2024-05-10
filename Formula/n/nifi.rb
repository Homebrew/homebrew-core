class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.26.0/nifi-1.26.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.26.0/nifi-1.26.0-bin.zip"
  sha256 "9feb9a6b8b002f17f0cfe4dc7f9f77bebc8608bdec6ec47bfddffa06934db79f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b88c9ca49d024544d2437c04b8c40e7140fdbd3f9748e991278ff6f996a7d2b7"
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
