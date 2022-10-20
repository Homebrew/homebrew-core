class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.16.1.tar.gz"
  sha256 "16ea52f67ac9778fe5b85eed35eac2b5e748ae1a7f3c736e3cdca9e6aeb6fe3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5c3cdf5838fe6365e4e87b69a7c8d389b0748f0435c7d33eeb1c64253f3936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a21d246855414c7b5d39b8b35ae08d80feca9392819b50360dce31f0bb88e501"
    sha256 cellar: :any_skip_relocation, monterey:       "fe1b8ae659860c889db8f2517b7306608ad7208d3a2847ae83e715ba1277424f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3abcc1f2b9c017f725f78dabe3de03d477f826f742f9eb266ceaf8705d412241"
    sha256 cellar: :any_skip_relocation, catalina:       "2b1bd52db7adf66d573b8eba772091d6a9132a5ccfa6c63c18f6c5604828fddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60d7e04bccbe3940e4cea0d21449e51b7156930a8aec512f4adbeaf1b1d679a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
