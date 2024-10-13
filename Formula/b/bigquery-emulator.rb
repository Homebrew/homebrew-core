class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "afa9d2d22f8e0a600bad1cd3732b485bb9869486f479d67b2486794f378f4256"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f93d3853282994ff14406f6c877db15ffb3dbe6ec6da31999ff897847ea0407a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de36c2b552cdbcf4e46c06237289215b423c4efda3a55f15ac9158efd4e89bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e8d239077ac4fa96b00b9f9d8542634262693c8be57addc4765d1393cbc3cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9af8274042e09ea070db4411737ab4ca0433c70eb85c6bc01b8278c939f267"
    sha256 cellar: :any_skip_relocation, sonoma:         "564f43a2518cc6f57c63e5248fbc908931b934d3c51a5a4e42845cae52ad6395"
    sha256 cellar: :any_skip_relocation, ventura:        "be3ef77e7304af45b2d7f95dd495eb84a23532a7f9b862e46404634d3176d647"
    sha256 cellar: :any_skip_relocation, monterey:       "68ec993e1dc9a20c56f285dc3f3c045c6b5a988989ca5c33597f817f1fe80fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1adb5a4472cb22c6f7e9e248ec9629703554d3269ede330bcf9fb0981fc2db2"
  end

  # use "go" again after https://github.com/goccy/bigquery-emulator/issues/348 is fixed and released
  depends_on "go@1.22" => :build

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
