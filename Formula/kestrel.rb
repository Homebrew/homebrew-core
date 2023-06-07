class Kestrel < Formula
  desc "Distributed message queue"
  homepage "https://twitter-archive.github.io/kestrel/"
  url "https://twitter-archive.github.io/kestrel/download/kestrel-2.4.1.zip"
  sha256 "5d72a301737cc6cc3908483ce73d4bdb6e96521f3f8c96f93b732d740aaea80c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "102f138c80ae525a4087650b554064fb06db3e8d8a507d43e009770fae9975fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b8c7f3a898f32a556efc9f79f1944f8739a458f07b671664357239d6a5b7e8"
    sha256 cellar: :any_skip_relocation, monterey:       "06f46153c7e30b36aded49e26e79879f4f4bce6ca713e352fcbb09d0ada905ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "8106b504796e7c73733c4206d00e2d7f7213e998729a9fe6c56a6016b14b822d"
    sha256 cellar: :any_skip_relocation, catalina:       "8106b504796e7c73733c4206d00e2d7f7213e998729a9fe6c56a6016b14b822d"
    sha256 cellar: :any_skip_relocation, mojave:         "8106b504796e7c73733c4206d00e2d7f7213e998729a9fe6c56a6016b14b822d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b8c7f3a898f32a556efc9f79f1944f8739a458f07b671664357239d6a5b7e8"
  end

  # See: https://github.com/twitter-archive/kestrel#status
  disable! date: "2022-09-14", because: :deprecated_upstream

  def install
    inreplace "scripts/kestrel.sh" do |s|
      s.change_make_var! "APP_HOME", libexec
      # Fix var paths.
      s.gsub! "/var", var
      # Fix path to script in help message.
      s.gsub! "Usage: /etc/init.d/${APP_NAME}.sh", "Usage: kestrel"
      # Don't call ulimit as not root.
      s.gsub! "ulimit -", "# ulimit -"
    end

    inreplace "config/production.scala", "/var", var

    libexec.install Dir["*"]
    (libexec/"scripts/kestrel.sh").chmod 0755
    (libexec/"scripts/devel.sh").chmod 0755

    (bin/"kestrel").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/scripts/kestrel.sh" "$@"
    EOS
  end

  def post_install
    (var/"log/kestrel").mkpath
    (var/"run/kestrel").mkpath
    (var/"spool/kestrel").mkpath
  end

  test do
    system bin/"kestrel", "status"
  end
end
