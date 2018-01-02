# Documentation: https://docs.brew.sh/Formula-Cookbook.html 
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula 
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST! 
 
class Eccodes < Formula 
  desc "Tools to manipulate grib files" 
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home" 
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.5.0-Source.tar.gz?api=v2" 
  sha256 "18ab44bc444168fd324d07f7dea94f89e056f5c5cd973e818c8783f952702e4e" 
 
  #bottle :disable, "needs to be bottled" 
 
  #option "with-netcdf", "Compile with netcdf support" 
   
  depends_on "cmake" => :build 
  depends_on "netcdf" #=> :optional 
  depends_on "hdf5" 
  #depends_on "jpg" #=> optional 
  depends_on "python" #=> optional
  depends_on "gcc" #?
 
  def install 
    # ENV.deparallelize  # if your formula fails when building in parallel 
 
    std_cmake_args = ["-DCMAKE_INSTALL_PREFIX=/usr/local/bin"] 
 
    # untar the package 
    system "tar xf eccodes-2.5.0-Source.tar" 
 
    # Remove unrecognized options if warned by configure 
    system "cmake", *std_cmake_args, "eccodes-2.5.0-Source" 
    system "make", "install" # if this fails, try separate make/make install steps 
  end 
 
  test do 
    # `test do` will create, run in and delete a temporary directory. 
    # 
    # This test will fail and we won't accept that! For Homebrew/homebrew-core 
    # this will need to be a test that verifies the functionality of the 
    # software. Run the test with `brew test eccodes`. Options passed 
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`. 
    # 
    # The installed folder is not in the path, so use the entire path to any 
    # executables being tested: `system "#{bin}/program", "do", "something"`. 
    system "false" 
  end 
end
