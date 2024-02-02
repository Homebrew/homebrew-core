class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  version "0.25.1"
  license "Apache-2.0"

  on_macos do
    url "https://github.com/apple/pkl/releases/download/#{version}/pkl-macos-amd64"
    sha256 "1da8d6c7eaca8a7efce6182bb9d7038b092a8e4a8824203a4ba0579a3804d52a"
    on_arm do
      url "https://github.com/apple/pkl/releases/download/#{version}/pkl-macos-aarch64"
      sha256 "ee4e1cf41d16fc98104139f0ccb254fa9f8b780cb61a0f12731da35a6c65f9dd"
    end
  end

  on_linux do
    url "https://github.com/apple/pkl/releases/download/#{version}/pkl-linux-amd64"
    sha256 "8fb43304342bd1d63d1e60d3dcfbbf76cfdc1dd15fd8cfd531fec559eecbd33d"
    on_arm do
      url "https://github.com/apple/pkl/releases/download/#{version}/pkl-linux-aarch64"
      sha256 "e34a249fba53cbdcce81136b0a47e85159a27e2ae0af9e4bebc4759f72ec3f01"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    bin.install "pkl-#{os}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("pkl eval -x bar -", "bar = 1")
  end
end
