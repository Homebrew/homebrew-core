class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.5.0/OpenCoarrays-2.5.0.tar.gz"
  sha256 "fca62bd93b8fdcb6ee68b9c96d26d93f7440c2da8942a5ddcb14159457454276"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "a827f29f1872e8dd6c144cfb1d42dacc30018ccef3940b56b9857153fc06a638" => :mojave
    sha256 "377ee03f5ce15076516e6c7c141076f78693e4b4e81648ed4b445281bafb976b" => :high_sierra
    sha256 "7d688179cb4e5ddeb1de8eda2c367b371f7b28ff6b2c6897b1a9274606112a35" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
  end
end
