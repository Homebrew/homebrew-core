class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "4f8c037d03cd23d2a44d74460b5399213e0efeb33d6cade25bfce25499c4699a"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f0f050d1741c7fe442509fe9e0a1191b64ca7eecffb984fe1ba46392774a6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deb1bca422e73c863817508468ba0e2561f94287b9c1089800c2cff2c9c27870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf048c05787db6445b24be1750fc5ca93e3cbe9c87a0e518dd164148e4dce42d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ade2550d64679971763a523c1ac51f130200d74050f0369c2fc6e0f67ff7d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "e43e92c74e0d821bee786cf4e831910ea1ae000d40dde6bf40fc975ee545ddcb"
    sha256 cellar: :any_skip_relocation, monterey:       "2010c1ef598e1e44418837fdac1050d0dd4a6e97828956bdc14e4b6432ed7517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70134164a24149d29e2139aae15e6c2cc7c4df5f89b58c0f1f0b49886c03d034"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=#{version} -X main.revision=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    port = free_port

    fork do
      exec bin/"bigquery-emulator", "--project=test", "--port=#{port}"
    end

    sleep 5
    system "nc", "-z", "localhost", port.to_s

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  end
end
