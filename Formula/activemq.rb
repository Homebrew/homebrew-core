class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.16.3/apache-activemq-5.16.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.16.3/apache-activemq-5.16.3-bin.tar.gz"
  sha256 "1846da2985ec64253ecc41a54f1477731eb4750fe840a9dd9fdfee88e5c94252"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21f6a33e97037eb0f2610588e1be30d59c45dfdea65f5633eb15463f1bed5ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fea1abd0d9c574c1180eef96b627d25557d76421cbf69d0be648ae5a448eb9"
    sha256 cellar: :any_skip_relocation, monterey:       "555c0807f5ed9ba4381c908581851eb00ef9bc02536e5c96780648894d862393"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
    sha256 cellar: :any_skip_relocation, catalina:       "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
    sha256 cellar: :any_skip_relocation, mojave:         "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
  end

  depends_on "openjdk"

  def install
    if OS.mac?
      rm_rf Dir["bin/linux-x86-*"]

      # Discard universal binaries without usable slices
      rm_f "bin/macosx/libwrapper.jnilib"
      rm_f "bin/macosx/wrapper" if Hardware::CPU.arm?
    else
      rm_rf "bin/macosx"
    end

    libexec.install Dir["*"]
    deuniversalize_machos
    (bin/"activemq").write_env_script libexec/"bin/activemq", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  service do
    run [opt_bin/"activemq", "start"]
    working_dir opt_libexec
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
