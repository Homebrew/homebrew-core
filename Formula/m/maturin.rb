class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "204f22de5c56a3d599f427344e7389270d71ea183bcc0c719c3725931459180b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bec08f6cc080622f677c398d15432b1255666cfc67b542587ca851b793563b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f22751a5b9ad93092689ffe45f44c656e1706753c42f0f1eaac07fbca330103b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df525ee57cab0f9329d70df81e3b76212d5b49897aa31c3ac5d6872299b39ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "336553717083e081fb4b1fd8a748620c7cd3e963749d2cbece117bf9761c2dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "d9beb4215c89e2bd83b7d9117ac2ff8561ac5058706b40a97547a6238fa9dcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a14f9d69ad03162a5218062eeb58d775f00fe9c1b83a59e2d65c436bb473ee2"
  end

  depends_on "python@3.13" => :test
  depends_on "rust"

  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python = "python3.13"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python, "-c", "import maturin"
  end
end
