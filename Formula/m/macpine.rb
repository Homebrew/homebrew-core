class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "7ee1af8484d66b0bbeaa14d9f42cda5f4cdc092cf1ec76a4a18e00b069511df3"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48f9e0a07604ea395d6698bcd1fc47655f80cffb801bbe9011994503cdb348d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb4529e5797e102909e9f4472b81e0c5092723c5e7e2b9488902f70e5ca5fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b1b5a2860147437639da7ed89efdbb8938e81f506cc5f81f84369dfa0a24284"
    sha256 cellar: :any_skip_relocation, sonoma:        "281fc13fca2a499e6c5e1dec0a279f97a8045daf7c51dbc3cdbc4176c9fd1d25"
    sha256 cellar: :any_skip_relocation, ventura:       "f58f87947a8f91c1ec980f720037d8ad4ac2684d1ab64aae166be6a0da7ee40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac17e462ab7187f6bed784db61262c8001947147a7c3878e50d9d603fff15fa0"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
