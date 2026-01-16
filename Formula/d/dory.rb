class Dory < Formula
  desc "Development proxy for docker"
  homepage "https://github.com/freedomben/dory"
  url "https://github.com/FreedomBen/dory/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8c385d898aed2de82f7d0ab5c776561ffe801dd4b222a07e25e5837953355b81"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9c554cd1ff4108aa4262eb12aa832ecd12632c0781352e211d67a3ba3c28b630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e75ebd666b1c2b3d1ff21d0cdc9d8f820935e41e32c12533a544ccc4563f44db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "445dc72e8fd5886e5378277044e12edabcdd9136857bbc7b259ef76a5d4941cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "801315212e458f3a16eba1e62acbe37a7ddec7fe6542b1546a0b01e4d33d8f27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801315212e458f3a16eba1e62acbe37a7ddec7fe6542b1546a0b01e4d33d8f27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "801315212e458f3a16eba1e62acbe37a7ddec7fe6542b1546a0b01e4d33d8f27"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab9300321c48cb22e9fb417d9f80b08def6219a4fc0fd1ea834e7ca43e50aee"
    sha256 cellar: :any_skip_relocation, ventura:        "dc275970eb94ef3bba02bd5bf12241e26e4a35f415fa9de16710d9fe80b978bc"
    sha256 cellar: :any_skip_relocation, monterey:       "dc275970eb94ef3bba02bd5bf12241e26e4a35f415fa9de16710d9fe80b978bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc275970eb94ef3bba02bd5bf12241e26e4a35f415fa9de16710d9fe80b978bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8238cb7a9ec990b6460404d79e97d9de59914803d0b9c6498f786194acf9eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af4be9da0d1d895883e8527052f05d6c6d2da3c4c24bf123c62bc8dc4a0973d4"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    shell_output(bin/"dory")

    system bin/"dory", "config-file"
    assert_path_exists testpath/".dory.yml", "Dory could not generate config file"

    version = shell_output("#{bin}/dory version")
    assert_match version.to_s, version, "Unexpected output of version"
  end
end
