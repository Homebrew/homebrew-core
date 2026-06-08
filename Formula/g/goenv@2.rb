class GoenvAT2 < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.41.tar.gz"
  sha256 "1dea67645157defd8b6f711f6197a4dabfd3a5f56d7d9c41a0d312c1797e606a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b675347b8a453a87033a593e2330b8730e0e1df2952285379593bf52f5806199"
  end

  keg_only :versioned_formula

  # Goenv version 3.0.0 was released 2026-05-04
  deprecate! date: "2026-05-04", because: "superseded by v3.x; disables 2028-12-31", replacement_formula: "goenv"

  # End-of-support on 2028-12-31: https://github.com/go-nv/goenv/pull/525
  disable! date: "2028-12-31", because: :unmaintained

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
      "plugins/go-build/test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Warning: no Go detected on the system", shell_output("#{bin}/goenv versions 2>&1", 1)
  end
end
