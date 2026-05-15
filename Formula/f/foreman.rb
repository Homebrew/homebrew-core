class Foreman < Formula
  desc "Manage Procfile-based applications"
  homepage "https://ddollar.github.io/foreman/"
  url "https://github.com/ddollar/foreman/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "d9428f9ab4c2e2b4f9e22a35d19237f5ad6789e2e71110cfe26f8715f4e3a58a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c78c793e9a91e349838d6e2d36be7f599d8a0778b5c4ce8d4d3d6fb88c6c485f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78c793e9a91e349838d6e2d36be7f599d8a0778b5c4ce8d4d3d6fb88c6c485f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78c793e9a91e349838d6e2d36be7f599d8a0778b5c4ce8d4d3d6fb88c6c485f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c78c793e9a91e349838d6e2d36be7f599d8a0778b5c4ce8d4d3d6fb88c6c485f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10202c8dbc359d723a3568da5b08773c19c49439999efe557a386ce96355ad3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10202c8dbc359d723a3568da5b08773c19c49439999efe557a386ce96355ad3a"
  end

  depends_on "ruby"

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/foreman.1"
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/foreman start")
  end
end
