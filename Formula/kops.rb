class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  head "https://github.com/kubernetes/kops.git"

  stable do
    url "https://github.com/kubernetes/kops/archive/1.5.3.tar.gz"
    sha256 "70d27f43580250a081333dd88d7437df5151063638da1eef567d78a04021b1cf"

    # Remove for > 1.5.3
    # Fix "sha1sum command is not available"
    # Upstream PR from 10 Mar 2017 "Fix makefile to correctly detect macOS shasum"
    patch do
      url "https://github.com/kubernetes/kops/pull/2097.patch"
      sha256 "238c431622e8be0229057811823210b97a9b17f8611f90d6aef3a76a97abef96"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9172496c06f759401db4d4387380f508a294c05b14de9e92f6b61e21486c89dd" => :sierra
    sha256 "876d549d0a7cee2b0517ef3224c7d3adef6646548accd174d447e52bd0a2916a" => :el_capitan
    sha256 "e305dcd14ef5cec6d9d03551a7134e1e6c79e17676961c4dceda826642dfbc4b" => :yosemite
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")
  end

  test do
    system "#{bin}/kops", "version"
  end
end
