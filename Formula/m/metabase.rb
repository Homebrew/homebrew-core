class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.49.9/metabase.jar"
  sha256 "d5052b5d8a4cbe7fc69bc963985e4c60a15108843fbf7be9a0c24425c491daf2"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c0479cae9bece13b8b78735044aade16afded6a476615c81f01ef99e980065"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b584c7d5993db0eed3bd45516a7409098faad705fbf25138e3c7bfe1c864fd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c5b8249aeb7461b0075077a4410adac6d8fb34ef9109c6c10d334d593a4bcdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3966b123858c60aeeb1aa33149d3bab8c08a7f89843c26b193c8e595580fc7b0"
    sha256 cellar: :any_skip_relocation, ventura:        "afece54642015ae880af31be6902916fd01056cc6a0bad6c24fbd1d29622714e"
    sha256 cellar: :any_skip_relocation, monterey:       "68d929bed01eaea8283d5f5e21a57ec93731de5ab41d757317d65a8a542fc6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f000305a24c80cc9be758dcbc34a0aa3346fa823e96695be15d618a499fc787"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
