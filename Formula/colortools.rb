class Colortools < Formula
  desc "Convert, import and export MacOS Color Picker (NSColorList) palettes"
  homepage "https://github.com/ramonpoca/ColorTools"
  url "https://github.com/ramonpoca/ColorTools/archive/0.2.tar.gz"
  sha256 "87fe9a8ba6edd1bebf697f9f821f15f2073b29825fa18ea68e77f5ccb2a7f3e0"

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/Ase2Clr" => "ase2clr"
    bin.install "build/Release/Clr2Ase" => "clr2ase"
    bin.install "build/Release/Clr2Obj" => "clr2obj"
    bin.install "build/Release/Html2Clr" => "html2clr"
  end

  test do
    # "foo --version and foo --help are bad tests. However, a bad test is better
    # than no test at all"
    #  - https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
    program_should_run_and_print_usage "ase2clr"
    program_should_run_and_print_usage "clr2ase"
    program_should_run_and_print_usage "clr2obj"
    program_should_run_and_print_usage "html2clr"
  end

  private

  def program_should_run_and_print_usage(cmd)
    assert_match "Usage:", shell_output("#{bin}/#{cmd} 2>&1 | grep Usage")
  end
end
