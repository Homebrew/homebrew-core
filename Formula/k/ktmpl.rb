class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/jimmycuadra/ktmpl"
  url "https://github.com/jimmycuadra/ktmpl/archive/refs/tags/0.9.1.tar.gz"
  sha256 "3377f10477775dd40e78f9b3d65c3db29ecd0553e9ce8a5bdcb8d09414c782e9"
  license "MIT"
  head "https://github.com/jimmycuadra/ktmpl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7a4f4f2bafee96a36ab50f17f2c89af0c75c46269cd2f1ebb35de8de69984866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2dc088f8bdd186bd390a9f26861ce4eaad7188aa36c5d8e269d0db6e4ca8dcb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbc4a95ff205822979bb6e785ae794efdeca86bdede06b3bc8c805a08536ce04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e549a6d1bf1f7d482349d5fcd6b592f7fe2281e2299ac0d8ecc1e8b45c3be605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1714ecf6633220ed65b1c3283862d889552d8c189500614586501f72d4a6e863"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "248f481ecd9cd1354cc55fe07877c6212fe2ffc3e031ea05c67ac42b621cfe5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "397b73eda60395e553fa2c0b251c030f51be17cd6a742356d50b0720613a148d"
    sha256 cellar: :any_skip_relocation, ventura:        "8191182f4620f45a4f092d7a854b3535a4f7bd9ded1103cddafd7b80662963da"
    sha256 cellar: :any_skip_relocation, monterey:       "058e0b3999bd65c216e64d22e57f2fd82d4a602cf4f39ef6d84c3de5d47deb78"
    sha256 cellar: :any_skip_relocation, big_sur:        "8339361fc53cd0ede0a635cb1dfb808068b4615b477de71a3df35607edec9149"
    sha256 cellar: :any_skip_relocation, catalina:       "77dbcd12d216cfa5bfc3ac870046630a86e13ce9936a92c3f7a99d1a91dd3a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2a12fdd012882fd444cee9c9d8e17f5f1d2a55542bde2a4564b3617a640ebc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2d87ec29cf08bcbc3c0c32d4a818f45cda4ce17ae6006e1185b1fa3cd25db1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.yml").write <<~YAML
      ---
      kind: "Template"
      apiVersion: "v1"
      metadata:
        name: "test"
      objects:
        - kind: "Service"
          apiVersion: "v1"
          metadata:
            name: "test"
          spec:
            ports:
              - name: "test"
                protocol: "TCP"
                targetPort: "$((PORT))"
            selector:
              app: "test"
      parameters:
        - name: "PORT"
          description: "The port the service should run on"
          required: true
          parameterType: "int"
    YAML
    system bin/"ktmpl", "test.yml", "-p", "PORT", "8080"
  end
end
