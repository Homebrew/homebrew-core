class Mirthsync < Formula
  desc "Version control for Mirth Connect and Open Integration Engine config"
  homepage "https://saga-it.com/products/mirthsync"
  url "https://github.com/SagaHealthcareIT/mirthsync/releases/download/3.7.0/mirthsync-3.7.0.tar.gz"
  sha256 "d962b21576d479166185b92c1d88540bd493ba2ab39c0b3b7908d8271dbbc98f"
  license "EPL-1.0"

  depends_on "openjdk"

  def install
    # The launcher resolves its jar as $(dirname $(readlink -f $0))/../lib,
    # so the tree has to stay intact; the wrapper in bin resolves through.
    libexec.install Dir["*"]
    (bin/"mirthsync").write_env_script libexec/"bin/mirthsync.sh",
                                       Language::Java.overridable_java_home_env
  end

  test do
    # --help exits 1: it reports the missing --target first, then prints usage.
    output = shell_output("#{bin}/mirthsync --help 2>&1", 1)
    assert_match "Usage: mirthsync", output
  end
end
